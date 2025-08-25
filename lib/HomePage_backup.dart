import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:crypto/crypto.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mi_insights/Login.dart';
import 'package:mi_insights/constants/Constants.dart';
import 'package:mi_insights/screens/ComingSoon.dart';
import 'package:mi_insights/screens/PolicyInformation.dart';
import 'package:mi_insights/screens/Reports/AttendanceReport.dart';
import 'package:mi_insights/screens/Reports/ClaimsReport.dart';
import 'package:mi_insights/screens/Reports/CommsReport.dart';
import 'package:mi_insights/screens/Reports/Executive/CustomersReport.dart';
import 'package:mi_insights/screens/Reports/Executive/ExecutiveCollectionsReport.dart';
import 'package:mi_insights/screens/Reports/Executive/ExecutiveCommisionsReport.dart';
import 'package:mi_insights/screens/Reports/Executive/ExecutiveSalesReport.dart';
import 'package:mi_insights/screens/Reports/MaintenanceReport.dart';
import 'package:mi_insights/screens/Reports/MarketingReport.dart';
import 'package:mi_insights/screens/Reports/MoralIndexReport.dart';
import 'package:mi_insights/screens/Reports/ReprintsAndCancellations.dart';
import 'package:mi_insights/screens/ReprintsAndCancellations.dart';
import 'package:mi_insights/screens/Sales%20Agent/SalesAgentCollectionsReport.dart';
import 'package:mi_insights/screens/Sales%20Agent/SalesAgentSalesReport.dart';
import 'package:mi_insights/screens/Valuetainment/Valuetainment.dart';
import 'package:mi_insights/services/Sales%20Agent/MyChats.dart';
import 'package:mi_insights/services/getAll.dart';
import 'package:mi_insights/services/inactivitylogoutmixin.dart';
import 'package:mi_insights/services/sharedpreferences.dart';
import 'package:mi_insights/services/syncAllData().dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/BusinessInfo.dart';
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
  "executive": [
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
    sectionmodel("Micro-Learn", VaLuetainmenthome(), "marketing",
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
    sectionmodel("Micro-Learn", VaLuetainmenthome(), "marketing",
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
  final String _correctPasswordHash = '414e773d5b7e5c06d564f594bf6384d0';

  String _hashPassword(String password) {
    return md5.convert(utf8.encode(password)).toString(); // Simple MD5 hash
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
                          String hashedInput =
                              _hashPassword(_passwordController.text);
                          print("hashedInput $hashedInput");
                          if (hashedInput == _correctPasswordHash &&
                              _passwordAttempts < 10) {
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
                          } else {
                            setState(() {
                              _errorMessage = "Incorrect Pin";
                              _passwordAttempts++;
                              if (_passwordAttempts >= 10) {
                                _errorMessage = "Too many attempts";
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
                          String hashedInput =
                              _hashPassword(_passwordController.text);
                          print("hashedInput $hashedInput");
                          if (hashedInput == _correctPasswordHash &&
                              _passwordAttempts < 10) {
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
                          } else {
                            setState(() {
                              _errorMessage = "Incorrect Pin";
                              _passwordAttempts++;
                              if (_passwordAttempts >= 10) {
                                _errorMessage = "Too many attempts";
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

  final carousel_slider.CarouselSliderController _controller =
      carousel_slider.CarouselSliderController();
  int _current = 0;

  var crossAxisCount;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
/*                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: ListTile(
                    title: Text(
                      "Sales Report",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xff121212),
                      ),
                    ),
                    //  trailing: Icon(Icons.arrow_forward),
                    leading:
                        Icon(CupertinoIcons.cart, color: Color(0xcc121212)),
                    onTap: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 30),
                  child: Container(
                    height: 1,
                    color: Color(0x33c2c5cc),
                  ),
                ),
                Constants.isAdmin
                    ? InkWell(
                        onTap: () {
                          /*   Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => admin()));*/
                        },
                        child: ListTile(
                          title: Text(
                            "Admin",
                            style: TextStyle(
                              color: Color(0xff121212),
                              fontFamily: "TradeGothic",
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          //   trailing: Icon(Icons.arrow_forward),
                          leading: Icon(CupertinoIcons.person,
                              color: Color(0xcc121212)),
                        ),
                      )
                    : Container(),*/

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: carousel_slider.CarouselSlider(
                  disableGesture: true,
                  carouselController: _controller,
                  options: carousel_slider.CarouselOptions(
                      autoPlay: true,
                      viewportFraction: 1.0,
                      clipBehavior: Clip.antiAlias,
                      padEnds: false,
                      aspectRatio: 16 / 9.5,
                      enlargeStrategy:
                          carousel_slider.CenterPageEnlargeStrategy.height,
                      enlargeCenterPage: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                  items: syncedImages == false
                      ? imgList
                          .map((item) => Builder(
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Card(
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      surfaceTintColor: Colors.white,
                                      color: Colors.white,
                                      child: Container(
                                        /* decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.grey.withOpacity(0.1),
                                        ),*/
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 0.0),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 1.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: Container(
                                              child: Image.asset(
                                                item,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ))
                          .toList()
                      : imgList
                          .map((item) => Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 5.0),
                                    child: CachedNetworkImage(
                                      imageUrl: item,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          Center(child: Icon(Icons.error)),
                                    ),
                                  );
                                },
                              ))
                          .toList(),
                ),
              ),
            ),
            if (imgList.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imgList.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black)
                              .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                    ),
                  );
                }).toList(),
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
            // Check if sectionsList is empty and show appropriate widget
            sectionsList.isEmpty
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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8, // Add vertical spacing
                      crossAxisCount: crossAxisCount,
                      childAspectRatio:
                          0.85, // Slightly taller to accommodate text
                    ),
                    itemCount: sectionsList.length,
                    padding: EdgeInsets.all(2.0),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {},
                        child: Container(
                          child: Stack(
                            children: [
                              InkWell(
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
                                  } else if (sectionsList[index].id ==
                                      "Claims") {
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
                                      "Payments") {
                                    //  Navigator.push(context,MaterialPageRoute(builder: (context) =>ExecutivePaymentReport())).then((_) {Constants.pageLevel = 1;});
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
                                                VaLuetainmenthome()));
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Circular Card Container
                                    Flexible(
                                      flex: 4,
                                      child: AspectRatio(
                                        aspectRatio:
                                            1.0, // Force perfect circle
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 8),
                                          child: Card(
                                            elevation: 6,
                                            surfaceTintColor: Colors.white,
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(360)),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(360),
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
                                                padding: EdgeInsets.all(
                                                    screenWidth < 600
                                                        ? 12.0
                                                        : 16.0), // Responsive padding
                                                child: SvgPicture.asset(
                                                  sectionsList[index].image,
                                                  color: Constants.ctaColorLight
                                                      .withOpacity(0.90),
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Text Container
                                    Flexible(
                                      flex: 2,
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        child: Text(
                                          sectionsList[index].id,
                                          style: TextStyle(
                                            fontSize:
                                                screenWidth < 600 ? 10 : 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
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
          setState(() {}); // This nested setState() is redundant - remove it
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

    super.initState();
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
      sync_leads(sales_formattedStartDate, sales_formattedEndDate);
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
