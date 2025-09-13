import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mi_insights/Login.dart';
import 'package:mi_insights/constants/Constants.dart';
import 'package:mi_insights/screens/Reports/Executive/ExecutiveMicroLearnReport.dart';
import 'package:mi_insights/services/sales_service.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:mi_insights/screens/ComingSoon.dart';
import 'package:mi_insights/screens/PolicyInformation.dart';
import 'package:mi_insights/screens/Reports/AttendanceReport.dart';
import 'package:mi_insights/screens/Reports/ClaimsReport.dart';
import 'package:mi_insights/screens/Reports/CommsReport.dart';
import 'package:mi_insights/screens/Reports/Executive/CustomersReport.dart';
import 'package:mi_insights/screens/Reports/Executive/ExecutiveCollectionsReport.dart';
import 'package:mi_insights/screens/Reports/Executive/ExecutiveCommisionsReport.dart';
import 'package:mi_insights/screens/Reports/Executive/ExecutivePaymentReport.dart';
import 'package:mi_insights/screens/Reports/Executive/ExecutiveSalesReport.dart';
import 'package:mi_insights/screens/Reports/MaintenanceReport.dart';
import 'package:mi_insights/screens/Reports/MarketingReport.dart';
import 'package:mi_insights/screens/Reports/MoralIndexReport.dart';
import 'package:mi_insights/screens/Reports/ReprintsAndCancellations.dart';
import 'package:mi_insights/screens/ReprintsAndCancellations.dart';
import 'package:mi_insights/screens/Sales%20Agent/SalesAgentCollectionsReport.dart';
import 'package:mi_insights/screens/Sales%20Agent/SalesAgentSalesReport.dart';
import 'package:mi_insights/screens/Testing/LeadInformationPage.dart';
import 'package:mi_insights/screens/Valuetainment/Valuetainment.dart';
import 'package:mi_insights/services/Sales%20Agent/MyChats.dart';
import 'package:mi_insights/services/getAll.dart';
import 'package:mi_insights/services/inactivitylogoutmixin.dart';
import 'package:mi_insights/services/sharedpreferences.dart';
import 'package:mi_insights/services/syncAllData().dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin/ClientSearchPage.dart';
import 'models/BusinessInfo.dart';
import 'utils/image_utils.dart';
import 'widgets/role_based_drawer.dart';

/*List<sectionmodel> sectionsList = [
  sectionmodel("Prospects", {}, "assets/icons/micro_l.svg"),
  sectionmodel("Sales", {}, "assets/icons/sales_logo.svg"),
  sectionmodel("Collections", {}, "assets/icons/collections_logo.svg"),
  sectionmodel("Claims", {}, "assets/icons/claims_logo.svg"),
  sectionmodel("Cust. Profile", {}, "assets/icons/customers.svg"),
  sectionmodel("Fulfillment", {}, "assets/icons/communications_logo.svg"),
  sectionmodel("Commission", {}, "assets/icons/commission_logo.svg"),
  sectionmodel("Maintenance", {}, "assets/icons/maintanence_report.svg"),
  sectionmodel("Attendance", {}, "assets/icons/attendance.svg"),
  sectionmodel("Pol. Search", {}, "assets/icons/policy_search.svg"),
  sectionmodel("Reprints", {}, "assets/icons/reprint_logo.svg"),
  sectionmodel("Morale Index", {}, "assets/icons/people_matters.svg"),
  sectionmodel("Micro-Learn", {}, "assets/icons/micro_l.svg"),
];*/

Map<String, List<sectionmodel>> m1 = {
  "administrator": [
    sectionmodel("Prospects", MarketingReport(), "marketing",
        "assets/icons/prospects.svg"),
    sectionmodel("Sales", ExecutivesSalesReport(), "sales",
        "assets/icons/sales_logo.svg"),
    sectionmodel("Collections", ExecutiveCollectionsReport(), "collections",
        "assets/icons/collections_logo.svg"),
    sectionmodel("Payments", ExecutivePaymentReport(), "payments",
        "assets/icons/collections_logo.svg"),
    sectionmodel(
        "Claims", ClaimsReport(), "claims", "assets/icons/claims_logo.svg"),
    sectionmodel("Cust. Profile", CustomersReport(), "customer_profile",
        "assets/icons/customers.svg"),
    sectionmodel("Fulfillment", CommsReport(), "fulfillment",
        "assets/icons/communications_logo.svg"),
    sectionmodel("Commission", ExecutiveCommisionsReport(), "commission",
        "assets/icons/commission_logo.svg"),
    sectionmodel("Maintenance", MaintenanceReport(), "maintenance",
        "assets/icons/maintanence_report.svg"),
    sectionmodel("Attendance", AttendanceReport(), "attendance",
        "assets/icons/attendance.svg"),
    sectionmodel("Pol. Search", PolicyInformation(), "policy_search",
        "assets/icons/policy_search.svg"),
    sectionmodel("Reprints", ReprintsAndCancellationsReport(), "reprints",
        "assets/icons/reprint_logo.svg"),
    sectionmodel("Morale Index", null, "morale_index",
        "assets/icons/people_matters.svg"), // Requires password
    sectionmodel("Micro-Learn", ExecutiveMicroLearnReport(), "marketing",
        "assets/icons/micro_l.svg"),
  ],
  "executive": [
    sectionmodel("Prospects", MarketingReport(), "marketing",
        "assets/icons/prospects.svg"),
    sectionmodel("Sales", ExecutivesSalesReport(), "sales",
        "assets/icons/sales_logo.svg"),
    sectionmodel("Collections", ExecutiveCollectionsReport(), "collections",
        "assets/icons/collections_logo.svg"),
    sectionmodel("Payments", ExecutivePaymentReport(), "payments",
        "assets/icons/collections_logo.svg"),
    sectionmodel(
        "Claims", ClaimsReport(), "claims", "assets/icons/claims_logo.svg"),
    sectionmodel("Cust. Profile", CustomersReport(), "customer_profile",
        "assets/icons/customers.svg"),
    sectionmodel("Fulfillment", CommsReport(), "fulfillment",
        "assets/icons/communications_logo.svg"),
    sectionmodel("Commission", ExecutiveCommisionsReport(), "commission",
        "assets/icons/commission_logo.svg"),
    sectionmodel("Maintenance", MaintenanceReport(), "maintenance",
        "assets/icons/maintanence_report.svg"),
    sectionmodel("Attendance", AttendanceReport(), "attendance",
        "assets/icons/attendance.svg"),
    sectionmodel("Pol. Search", PolicyInformation(), "policy_search",
        "assets/icons/policy_search.svg"),
    sectionmodel("Reprints", ReprintsAndCancellationsReport(), "reprints",
        "assets/icons/reprint_logo.svg"),
    sectionmodel("Morale Index", null, "morale_index",
        "assets/icons/people_matters.svg"), // Requires password
    sectionmodel("Micro-Learn", ExecutiveMicroLearnReport(), "marketing",
        "assets/icons/micro_l.svg"),
  ],
  "insurer": [
    sectionmodel("Prospects", MarketingReport(), "marketing",
        "assets/icons/prospects.svg"),
    sectionmodel("Sales", ExecutivesSalesReport(), "sales",
        "assets/icons/sales_logo.svg"),
    sectionmodel("Collections", ExecutiveCollectionsReport(), "collections",
        "assets/icons/collections_logo.svg"),
    sectionmodel("Payments", ExecutivePaymentReport(), "payments",
        "assets/icons/collections_logo.svg"),
    sectionmodel(
        "Claims", ClaimsReport(), "claims", "assets/icons/claims_logo.svg"),
    sectionmodel("Cust. Profile", CustomersReport(), "customer_profile",
        "assets/icons/customers.svg"),
    sectionmodel("Fulfillment", CommsReport(), "fulfillment",
        "assets/icons/communications_logo.svg"),
    sectionmodel("Commission", ExecutiveCommisionsReport(), "commission",
        "assets/icons/commission_logo.svg"),
    sectionmodel("Maintenance", MaintenanceReport(), "maintenance",
        "assets/icons/maintanence_report.svg"),
    sectionmodel("Attendance", AttendanceReport(), "attendance",
        "assets/icons/attendance.svg"),
    sectionmodel("Pol. Search", PolicyInformation(), "policy_search",
        "assets/icons/policy_search.svg"),
    sectionmodel("Reprints", ReprintsAndCancellationsReport(), "reprints",
        "assets/icons/reprint_logo.svg"),
    sectionmodel("Morale Index", null, "morale_index",
        "assets/icons/people_matters.svg"), // Requires password
    sectionmodel("Micro-Learn", ExecutiveMicroLearnReport(), "marketing",
        "assets/icons/micro_l.svg"),
  ],
  "temporary_tester": [
    sectionmodel("Prospects", MarketingReport(), "marketing",
        "assets/icons/prospects.svg"),
    sectionmodel("Sales", ExecutivesSalesReport(), "sales",
        "assets/icons/sales_logo.svg"),
    sectionmodel("Collections", ExecutiveCollectionsReport(), "collections",
        "assets/icons/collections_logo.svg"),
    sectionmodel(
        "Claims", ClaimsReport(), "claims", "assets/icons/claims_logo.svg"),
    sectionmodel("Cust. Profile", CustomersReport(), "customer_profile",
        "assets/icons/customers.svg"),
    sectionmodel("Fulfillment", CommsReport(), "fulfillment",
        "assets/icons/communications_logo.svg"),
    sectionmodel("Commission", ExecutiveCommisionsReport(), "commission",
        "assets/icons/commission_logo.svg"),
    sectionmodel("Maintenance", MaintenanceReport(), "maintenance",
        "assets/icons/maintanence_report.svg"),
    sectionmodel("Attendance", AttendanceReport(), "attendance",
        "assets/icons/attendance.svg"),
    sectionmodel("Pol. Search", PolicyInformation(), "policy_search",
        "assets/icons/policy_search.svg"),
    sectionmodel("Reprints", ReprintsAndCancellationsReport(), "reprints",
        "assets/icons/reprint_logo.svg"),
    sectionmodel("Morale Index", null, "morale_index",
        "assets/icons/people_matters.svg"), // Requires password
    sectionmodel("Micro-Learn", ExecutiveMicroLearnReport(), "marketing",
        "assets/icons/micro_l.svg"),
  ],
  "sales": [
    sectionmodel(
        "My Sales", SalesAgentReport(), "sales", "assets/icons/sales_logo.svg"),
    sectionmodel("My Collect", SalesAgentCollectionsReport(), "collections",
        "assets/icons/collections_logo.svg"),
    sectionmodel("My Comm", null, "commission",
        "assets/icons/commission_logo.svg"), // Requires password
    sectionmodel(
        "My Chats", myChats(), "attendance", "assets/icons/my_chats.svg"),
    sectionmodel("Micro-Learn", ExecutiveMicroLearnReport(), "marketing",
        "assets/icons/micro_l.svg"),
  ],
  "specialist": [
    sectionmodel(
        "My Sales", SalesAgentReport(), "sales", "assets/icons/sales_logo.svg"),
    sectionmodel("My Collect", SalesAgentCollectionsReport(), "collections",
        "assets/icons/collections_logo.svg"),
    sectionmodel("My Comm", null, "commission",
        "assets/icons/commission_logo.svg"), // Requires password
    sectionmodel(
        "My Chats", myChats(), "attendance", "assets/icons/my_chats.svg"),
    sectionmodel("Micro-Learn", ExecutiveMicroLearnReport(), "marketing",
        "assets/icons/micro_l.svg"),
  ]
};

List<sectionmodel> sectionsList = [];
List<sectionmodel> unFilteredSectionsList = [];

bool _obscureText = true;

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final GlobalKey<ScaffoldState> _key = GlobalKey();

class _MyHomePageState extends State<MyHomePage> with InactivityLogoutMixin {
  int _counter = 0;

  late List<String> imgList = [];
  bool syncedImages = false;

  final TextEditingController _passwordController = TextEditingController();

  int _passwordAttempts = 0;
  String _errorMessage = '';
  DateTime? _lockoutEndTime;

  bool _isLockedOut() {
    if (_lockoutEndTime == null) return false;
    return DateTime.now().isBefore(_lockoutEndTime!);
  }

  Duration? _getRemainingLockoutTime() {
    if (_lockoutEndTime == null) return null;
    final remaining = _lockoutEndTime!.difference(DateTime.now());
    return remaining.isNegative ? null : remaining;
  }

  void _showPasswordDialog() {
    showDialog(
      context: context,
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
            backgroundColor: Colors.white,
            contentPadding: const EdgeInsets.only(left: 0.0),
            title: Padding(
              padding: const EdgeInsets.only(top: 14.0, left: 0, right: 0),
              child: Text(
                'THIS VIEW IS PASSWORD PROTECTED',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, top: 0.0, bottom: 0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0xff44556a)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(
                            "Privacy and Comfort",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, right: 8),
                            child: Text(
                              "This view is availed exclusively to Senior Executives as it is important that employee’s privacy when they share their sentiments is kept confidential to encourage authentic inputs.",
                              style: TextStyle(
                                  fontSize: 12.5, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 0.0, left: 0, right: 12),
                    child: Text(
                      'Please Enter Your Pin And Press Continue',
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 0.0,
                    ),
                    child: Container(
                      width: 250,
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: 'Pin',
                          hintStyle: TextStyle(
                            color: Colors.grey.withOpacity(0.75),
                          ),
                          contentPadding: EdgeInsets.only(top: 18),
                          errorText:
                              _errorMessage.isEmpty ? null : _errorMessage,
                          suffixIconConstraints: BoxConstraints(maxHeight: 18),
                          suffixIcon: IconButton(
                            style: ElevatedButton.styleFrom(
                              splashFactory: NoSplash.splashFactory,
                            ),
                            icon: Padding(
                              padding: const EdgeInsets.only(
                                right: (8.0),
                              ),
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey.withOpacity(0.75),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(
                            0.35,
                          ),
                          borderRadius: BorderRadius.circular(360)),
                      width: 125,
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
                                  'Cancel',
                                  style: TextStyle(
                                      color: Constants.ctaColorLight,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            )),
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      child: InkWell(
                        onTap: () {
                          // Check if user is locked out
                          if (_isLockedOut()) {
                            final remaining = _getRemainingLockoutTime();
                            MotionToast.error(
                              title: Text("Account Locked",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              description: Text(
                                  "Please try again in ${remaining!.inMinutes} minutes",
                                  style: TextStyle(color: Colors.white)),
                              borderRadius: 10,
                              displayBorder: true,
                            ).show(context);
                            return;
                          }

                          // Check password
                          if (_passwordController.text ==
                              Constants.cec_employeeid.toString()) {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MoraleIndexReport(),
                              ),
                            ).then((_) {
                              Constants.pageLevel = 1;
                            });
                            _passwordAttempts = 0;
                            _lockoutEndTime = null;
                          } else {
                            setState(() {
                              _passwordAttempts++;

                              if (_passwordAttempts >= 5) {
                                _lockoutEndTime =
                                    DateTime.now().add(Duration(hours: 1));
                                MotionToast.error(
                                  title: Text("Account Locked",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  description: Text(
                                      "Too many failed attempts. Account locked for 1 hour.",
                                      style: TextStyle(color: Colors.white)),
                                  borderRadius: 10,
                                  displayBorder: true,
                                ).show(context);
                              } else if (_passwordAttempts >= 3) {
                                final remaining = 5 - _passwordAttempts;
                                MotionToast.error(
                                  title: Text("Warning",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  description: Text(
                                      "$remaining more attempt${remaining > 1 ? 's' : ''} remaining until temporary lock",
                                      style: TextStyle(color: Colors.white)),
                                  borderRadius: 10,
                                  displayBorder: true,
                                ).show(context);
                                _errorMessage =
                                    "Incorrect Pin - $remaining attempts left";
                              } else {
                                _errorMessage = "Incorrect Pin";
                              }
                            });
                          }
                          _passwordController.clear();
                        },
                        child: Container(
                            width: 125,
                            height: 38,
                            decoration: BoxDecoration(
                                color: Constants.ctaColorLight,
                                borderRadius: BorderRadius.circular(360)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 14.0, right: 14, top: 5, bottom: 5),
                              child: Center(
                                child: const Text(
                                  'Continue',
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

  void _showCommissionsDialog() {
    showDialog(
      context: context,
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
            backgroundColor: Colors.white,
            contentPadding: const EdgeInsets.only(left: 0.0),
            title: Padding(
              padding: const EdgeInsets.only(top: 14.0, left: 0, right: 0),
              child: Text(
                'THIS VIEW IS PASSWORD PROTECTED',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, top: 0.0, bottom: 0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0xff44556a)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(
                            "Private and Confidential",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, right: 8),
                            child: Text(
                              "The information contained on this tab includes sensitive and confidential data related to employee earnings and commission figures. Access is strictly limited to authorized individuals.",
                              style: TextStyle(
                                  fontSize: 12.5, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 0.0, left: 0, right: 12),
                    child: Text(
                      'Please Enter Your Pin And Press Continue',
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 0.0,
                    ),
                    child: Container(
                      width: 250,
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: 'Pin',
                          hintStyle: TextStyle(
                            color: Colors.grey.withOpacity(0.75),
                          ),
                          contentPadding: EdgeInsets.only(top: 18),
                          errorText:
                              _errorMessage.isEmpty ? null : _errorMessage,
                          suffixIconConstraints: BoxConstraints(maxHeight: 18),
                          suffixIcon: IconButton(
                            style: ElevatedButton.styleFrom(
                              splashFactory: NoSplash.splashFactory,
                            ),
                            icon: Padding(
                              padding: const EdgeInsets.only(
                                right: (8.0),
                              ),
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey.withOpacity(0.75),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(
                            0.35,
                          ),
                          borderRadius: BorderRadius.circular(360)),
                      width: 125,
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
                                  'Cancel',
                                  style: TextStyle(
                                      color: Constants.ctaColorLight,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            )),
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      child: InkWell(
                        onTap: () {
                          // Check if user is locked out
                          if (_isLockedOut()) {
                            final remaining = _getRemainingLockoutTime();
                            MotionToast.error(
                              title: Text("Account Locked",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              description: Text(
                                  "Please try again in ${remaining!.inMinutes} minutes",
                                  style: TextStyle(color: Colors.white)),
                              borderRadius: 10,
                              displayBorder: true,
                            ).show(context);
                            return;
                          }

                          // Check password
                          if (_passwordController.text ==
                              Constants.cec_employeeid.toString()) {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ExecutiveCommisionsReport(),
                              ),
                            ).then((_) {
                              Constants.pageLevel = 1;
                            });
                            _passwordAttempts = 0;
                            _lockoutEndTime = null;
                          } else {
                            setState(() {
                              _passwordAttempts++;

                              if (_passwordAttempts >= 5) {
                                _lockoutEndTime =
                                    DateTime.now().add(Duration(hours: 1));
                                MotionToast.error(
                                  title: Text("Account Locked",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  description: Text(
                                      "Too many failed attempts. Account locked for 1 hour.",
                                      style: TextStyle(color: Colors.white)),
                                  borderRadius: 10,
                                  displayBorder: true,
                                ).show(context);
                              } else if (_passwordAttempts >= 3) {
                                final remaining = 5 - _passwordAttempts;
                                MotionToast.error(
                                  title: Text("Warning",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  description: Text(
                                      "$remaining more attempt${remaining > 1 ? 's' : ''} remaining until temporary lock",
                                      style: TextStyle(color: Colors.white)),
                                  borderRadius: 10,
                                  displayBorder: true,
                                ).show(context);
                                _errorMessage =
                                    "Incorrect Pin - $remaining attempts left";
                              } else {
                                _errorMessage = "Incorrect Pin";
                              }
                            });
                          }
                          _passwordController.clear();
                        },
                        child: Container(
                            width: 125,
                            height: 38,
                            decoration: BoxDecoration(
                                color: Constants.ctaColorLight,
                                borderRadius: BorderRadius.circular(360)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 14.0, right: 14, top: 5, bottom: 5),
                              child: Center(
                                child: const Text(
                                  'Continue',
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

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 6,
        shadowColor: Colors.grey.withOpacity(0.3),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          if (Constants.myUserRoleLevel.toLowerCase() == "administrator" ||
              Constants.myUserRoleLevel.toLowerCase() == "underwriter")
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          backgroundColor: Colors.white,
                          child: Container(
                            constraints:
                                BoxConstraints(minHeight: 300, maxHeight: 400),

                            //padding: EdgeInsets.symmetric(horizontal: 20),
                            child: SingleChildScrollView(
                              physics: NeverScrollableScrollPhysics(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClientSearchPage(onClientSelected: (val) {}),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Icon(CupertinoIcons.arrow_right_arrow_left)),
            )
        ],
        leading: InkWell(
            onTap: () {
              _key.currentState?.openDrawer();
            },
            child: RotatedBox(
              quarterTurns: 1,
              child: Container(
                height: 31,
                width: 32,
                child: Icon(
                  FeatherIcons.barChart2,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            )),
      ),
      // Use the role-based drawer
      drawer: RoleBasedDrawer.buildDrawer(
        context,
        userRole: Constants.myUserRole,
        userModules: Constants.myUserModules,
        onPasswordRequired: _showPasswordDialog,
        onCommissionPasswordRequired: _showCommissionsDialog,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (Constants.selectedClientName.isNotEmpty)
              SizedBox(
                height: 12,
              ),
            if (Constants.selectedClientName.isNotEmpty)
              Row(
                children: [
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text(
                      Constants.selectedClientName,
                      style: TextStyle(fontSize: 9.5, color: Colors.black),
                    ),
                  )
                ],
              ),
            if (Constants.selectedClientName.isEmpty)
              SizedBox(
                height: 10,
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ImageUtils.buildNetworkImageWithFallback(
                imageUrls: imgList,
                baseUrl: Constants.insightsBackendBaseUrl,
                height: MediaQuery.of(context).size.width / (16 / 9.5),
                showFallbackWhenAllFail: true,
              ),
            ),
            // Text(Constants.latestNotification.toJson().toString()),
            if (Constants.latestNotification.title.isNotEmpty &&
                Constants.account_type != "executive")
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /*   Text(
                          "Latest Notification",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 8,
                        ),*/
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${Constants.latestNotification.notificationType} : " +
                                    Constants.latestNotification.title,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        /*  SizedBox(
                          height: 8,
                        ),*/
                        /*    Text(
                          Constants.latestNotification.content,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),*/
                      ],
                    ),
                  ),
                ),
              ),
            // Responsive Grid with LayoutBuilder
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate responsive grid based on screen width
                  final screenWidth = MediaQuery.of(context).size.width;
                  final screenHeight = MediaQuery.of(context).size.height;

                  // Determine crossAxisCount based on screen width
                  int crossAxisCount;
                  if (screenWidth < 390) {
                    crossAxisCount =
                        4; // Smaller screens (iPhone 13 mini and below)
                  } else if (screenWidth >= 390 && screenWidth < 600) {
                    crossAxisCount = 4; // iPhone 14 and above
                  } else if (screenWidth >= 600 && screenWidth < 900) {
                    crossAxisCount = 4; // Medium screens (tablets)
                  } else {
                    crossAxisCount =
                        5; // Larger screens (large tablets/desktop)
                  }

                  return sectionsList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lock_outline,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 16),
                              Text(
                                "No Modules Assigned",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "No modules have been assigned to this role.\nPlease contact your administrator.",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 4,
                            mainAxisSpacing:
                                4, // Increased spacing for better layout
                            crossAxisCount: crossAxisCount,
                            childAspectRatio:
                                0.75, // Adjusted to accommodate text below circle
                          ),
                          itemCount: sectionsList.length,
                          padding: EdgeInsets.all(2.0),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                print("index " + index.toString());
                                if (sectionsList[index].id == "Sales") {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ExecutivesSalesReport()))
                                      .then((_) {
                                    Constants.pageLevel = 1;
                                  });
                                } else if (sectionsList[index].id ==
                                    "Cust. Profile") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CustomersReport())).then((_) {
                                    Constants.pageLevel = 1;
                                  });
                                } else if (sectionsList[index].id ==
                                    "Collections") {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ExecutiveCollectionsReport()))
                                      .then((_) {
                                    Constants.pageLevel = 1;
                                  });
                                } else if (sectionsList[index].id ==
                                    "Maintenance") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MaintenanceReport())).then((_) {
                                    Constants.pageLevel = 1;
                                  });
                                } else if (sectionsList[index].id == "Claims") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ClaimsReport())).then((_) {
                                    Constants.pageLevel = 1;
                                  });
                                } else if (sectionsList[index].id ==
                                    "Reprints") {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ReprintsAndCancellationsReport()))
                                      .then((_) {
                                    Constants.pageLevel = 1;
                                  });
                                } else if (sectionsList[index].id ==
                                    "Pol. Search") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PolicyInformation())).then((_) {
                                    Constants.pageLevel = 1;
                                  });
                                } else if (sectionsList[index].id ==
                                        "Payments" ||
                                    sectionsList[index].id == "Bordereaux") {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ExecutivePaymentReport()))
                                      .then((_) {
                                    Constants.pageLevel = 1;
                                  });
                                } else if (sectionsList[index].id ==
                                    "Fulfillment") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CommsReport())).then((_) {
                                    Constants.pageLevel = 1;
                                  });
                                } else if (sectionsList[index].id ==
                                    "Micro-Learn") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ExecutiveMicroLearnReport()));
                                } else if (sectionsList[index].id ==
                                    "My Sales") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SalesAgentReport()));
                                } else if (index == 10) {
                                  _showPasswordDialog();
                                } else if (sectionsList[index].id ==
                                    "Commission") {
                                  _showCommissionsDialog();
                                } else if (sectionsList[index].id ==
                                    "Prospects") {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  sectionsList[index].map))
                                      .then((_) {
                                    Constants.pageLevel = 1;
                                  });
                                } else if (sectionsList[index].id ==
                                    "Morale Index") {
                                  _showPasswordDialog();
                                  Constants.pageLevel = 1;
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ComingSoon())).then((_) {
                                    Constants.pageLevel = 1;
                                  });
                                }
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Perfect Circle Container
                                  Expanded(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        // Get the smaller dimension to ensure perfect circle
                                        double size = constraints.maxWidth <
                                                constraints.maxHeight
                                            ? constraints.maxWidth
                                            : constraints.maxHeight;

                                        // Ensure we have some margin
                                        size = size * 0.85;

                                        return Center(
                                          child: Container(
                                            width: size,
                                            height: size,
                                            child: Card(
                                              elevation: 6,
                                              surfaceTintColor: Colors.white,
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(size /
                                                        2), // Perfect circle
                                              ),
                                              child: Container(
                                                width: size,
                                                height: size,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          size / 2),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.04),
                                                      spreadRadius: 2,
                                                      blurRadius: 4,
                                                      offset: Offset(0, -2),
                                                    ),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(size *
                                                      0.2), // Responsive padding
                                                  child: SvgPicture.asset(
                                                    sectionsList[index].image,
                                                    color: Constants
                                                        .ctaColorLight
                                                        .withOpacity(0.90),
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  // Text Container
                                  SizedBox(height: 8), // Fixed spacing
                                  Container(
                                    height: 30, // Fixed height for text
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4),
                                    child: Text(
                                      sectionsList[index].id,
                                      style: TextStyle(
                                        fontSize: crossAxisCount == 4
                                            ? 10
                                            : crossAxisCount == 3
                                                ? 10
                                                : 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _checkLeadFormCompletion() async {
    // Only check lead form completion for new leads/prospects, not existing users with roles
    if (Constants.myUserRole.isEmpty ||
        Constants.myUserRole.toLowerCase() == "lead" ||
        Constants.myUserRole.toLowerCase() == "prospect") {
      bool? isCompleted = await Sharedprefs.getLeadCompletedSharedPreference();
      if (isCompleted != true) {
        // Navigate to LeadInformationPage if not completed
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LeadInformationPage(),
            ),
          );
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Constants.selectedClientName = "";

    // Check if lead form has been completed
    _checkLeadFormCompletion();

    // _fetchClients(clientId: Constants.cec_client_id);
    if (Constants.myUserRole.isEmpty) {
      sectionsList = [];
    } else {
      if (kDebugMode) {
        print("gffgghg0 $m1 ${Constants.myUserRole}");
      }

      // Fix: Check if the key exists and the value is not null
      if (m1.containsKey(Constants.myUserRole) &&
          m1[Constants.myUserRole] != null) {
        unFilteredSectionsList = m1[Constants.myUserRole]!;
        print("gffgghg1 ${unFilteredSectionsList.length}");
        print("gffgghg2 ${Constants.myUserModules}");

        if (m1.containsKey(Constants.myUserRole.toLowerCase())) {
          sectionsList =
              m1[Constants.myUserRole.toLowerCase()]!.where((section) {
            return Constants.myUserModules.contains(section.module);
          }).toList();
          setState(() {});
        }

        // Print filtered sections
        for (var section in sectionsList) {
          print("Section: ${section.id}, Module: ${section.module}");
        }
      } else {
        // Handle the case where the key doesn't exist or value is null
        print(
            "Warning: No sections found for user role: ${Constants.myUserRole}");
        unFilteredSectionsList = [];
        sectionsList = [];
      }
    }

    Sharedprefs.getbannersSharedPreference().then((value) {
      setState(() {
        if (value != null && value.isNotEmpty) {
          imgList = value;
          syncedImages = true;
        } else {
          imgList = [
            'assets/business_logos/pop_and_spin1.png',
            "assets/business_logos/pop_and_spin2.png",
            "assets/business_logos/pop_and_spin3.png"
          ];
        }
      });
      print(imgList);
    });

    getBusinessDetails();
    startInactivityTimer();
    refreshScripConfig();
    getAllUsers(
        Constants.cec_client_id.toString(), Constants.cec_client_id.toString());
    getAllBranches(context, Constants.cec_client_id.toString(),
        Constants.cec_client_id.toString());
    //if (Constants.isDataSynced == false) syncAllData(context);

    Future.delayed(Duration(seconds: 1)).then((value) {
      Constants.screenWidth = MediaQuery.of(context).size.width;
      Constants.screenHeight = MediaQuery.of(context).size.height;
    });

    Constants.pageLevel = 1;
    sync_all_data();

    // Check if user is administrator/underwriter and no client is selected
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if ((Constants.myUserRoleLevel.toLowerCase() == "administrator" ||
              Constants.myUserRoleLevel.toLowerCase() == "underwriter") &&
          Constants.selectedClientName.isEmpty) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              backgroundColor: Colors.white,
              child: Container(
                constraints: BoxConstraints(minHeight: 300, maxHeight: 400),

                //padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClientSearchPage(onClientSelected: (val) {}),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    });
  }

  void refreshScripConfig() {
    SalesService salesService = SalesService();
    salesService.fetchScriptConfig().then((val) {
      //Constants.currentConfigAvailable = val;

      if (kDebugMode) {
        print("gghhghg ${val.paragraphs.length}");
      }
      //filterPageData();

      setState(() {});
    });
    salesService.fetchParlourConfig(Constants.cec_client_id).then((val) {
      if (val != null) {
        if (kDebugMode) {
          // if (val.mainRates.isNotEmpty)
          // print("Parlour config main rate: ${val.mainRates[0].amount}");
        }
        Constants.currentParlourConfig = val;
      }
    });
  }

  bool sync_all_data() {
    DateTime? startDate = DateTime.now();
    DateTime? endDate = DateTime.now();
    startDate = DateTime.now().subtract(Duration(days: 7));
    endDate = DateTime.now().add(Duration(days: 3));

    String sales_formattedStartDate =
        DateFormat('yyyy-MM-dd').format(startDate);
    String sales_formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);
    Future.delayed(Duration(minutes: 3)).then((value) {
      //sync_leads(sales_formattedStartDate, sales_formattedEndDate);
    });
    return true;
  }

  Future<void> sync_leads(
      String sales_formattedStartDate, String sales_formattedEndDate) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST',
        Uri.parse(''
            '${Constants.baseUrl2}/files/process_and_update_leads_summary/'));

    request.body = json.encode({
      "client_id": Constants.cec_client_id,
      "start_date": sales_formattedStartDate,
      "end_date": sales_formattedEndDate,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("Successfully synced leads");
      }
    } else {
      if (kDebugMode) {
        print("ddsffdgh ${response.reasonPhrase}");
      }
    }
  }

  Future<void> sync_normalize_reports_data(
      String sales_formattedStartDate, String sales_formattedEndDate) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST',
        Uri.parse(''
            '${Constants.baseUrl2}/files/normalize_reports_data/'));

    request.body = json.encode({
      "client_id": Constants.cec_client_id,
      "start_date": sales_formattedStartDate,
      "end_date": sales_formattedEndDate,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
    } else {}
    if (kDebugMode) {
      print("Successfully synced normalize_reports_data");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  getBusinessDetails() async {
    String baseUrl = "${Constants.baseUrl}";
    String urlPath = "/parlour/company_info/";
    String apiUrl = baseUrl + urlPath;
    print("apiUrl $apiUrl");
    DateTime now = DateTime.now();
    Map<String, dynamic> requestBody = {
      "token": "kjhjguytuyghjgjhg765764tyfu",
      "cec_client_id": Constants.cec_client_id,
    };

    print("requestBody ${requestBody}");

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
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (kDebugMode) {
          // print("datax_business $data");
        }
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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String businessInfoJson =
            jsonEncode(Constants.currentBusinessInfo.toJson());
        await prefs.setString('businessInfo', businessInfoJson);
      } else {
        var data = jsonDecode(response.body);
        print("datajhhj $data");
        //setState(() {});

        print("Request failed with status: ${response.statusCode}");
      }

      // Perform your transaction logic here

      // Close the dialog
    } catch (error) {
      print("Error: $error");
    }
  }

  // Helper function to determine if a path is an asset path
  bool _isAssetPath(String path) {
    return path.startsWith('assets/') ||
        path.startsWith('asset/') ||
        (!path.startsWith('http://') &&
            !path.startsWith('https://') &&
            !path.contains('://'));
  }
}

class sectionmodel {
  String id;
  dynamic map;
  String module;
  String image;
  sectionmodel(this.id, this.map, this.module, this.image);
}

int getItemCountPerRow(BuildContext context) {
  double minTileWidth = 100; // Set your minimum tile width
  double availableWidth = MediaQuery.of(context)
      .size
      .width; // Get the available width of the screen

  int count = (availableWidth / minTileWidth)
      .round(); // Calculate how many tiles can fit in the row
  print(
      "minTileWidth: $minTileWidth, availableWidth: $availableWidth, count: $count");

  return count > 0 ? count : 1; // Ensure at least 1 tile per row
}
