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
import 'package:mi_insights/Login.dart';
import 'package:mi_insights/constants/Constants.dart';
import 'package:mi_insights/screens/ComingSoon.dart';
import 'package:mi_insights/screens/PolicyInformation.dart';
import 'package:mi_insights/screens/Reports/ClaimsReport.dart';
import 'package:mi_insights/screens/Reports/CommsReport.dart';
import 'package:mi_insights/screens/Reports/Executive/ExecutiveCollectionsReport.dart';
import 'package:mi_insights/screens/Reports/Executive/ExecutiveCommisionsReport.dart';
import 'package:mi_insights/screens/Reports/Executive/ExecutiveSalesReport.dart';
import 'package:mi_insights/screens/Reports/MaintenanceReport.dart';
import 'package:mi_insights/screens/Reports/MoralIndexReport.dart';
import 'package:mi_insights/screens/ReprintsAndCancellations.dart';
import 'package:mi_insights/services/getAll.dart';
import 'package:mi_insights/services/inactivitylogoutmixin.dart';
import 'package:mi_insights/services/syncAllData().dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/BusinessInfo.dart';

List<sectionmodel> sectionsList = [
  sectionmodel(
      "Corporate", {}, "assets/icons/cooperate.svg", coperate_sectionsList),
  sectionmodel("Affinity", {}, "assets/icons/affinity.svg", []),
  sectionmodel("Individual", {}, "assets/icons/individual.svg", []),
  sectionmodel("Micro-Learn", {}, "assets/icons/micro_l.svg", []),
];

List<sectionmodel> coperate_sectionsList = [
  sectionmodel("Preserve Value", {}, "", preserve_value_sectionsList),
  sectionmodel("Sustain Trust", {}, "", sustain_trust_sectionsList),
  sectionmodel(
      "Relationship Stability", {}, "", relationship_stability_sectionsList),
  sectionmodel("Innovation", {}, "", innovation_sectionsList),
  sectionmodel("Comms & Updates", {}, "", comms_and_updates_sectionsList),
  sectionmodel("Social Impact", {}, "", social_impact_sectionsList),
  sectionmodel("Service Standards", {}, "", service_standards_sectionsList),
];
List<sectionmodel> preserve_value_sectionsList = [
  sectionmodel("Sales", {}, "", []),
  sectionmodel("Earning", {}, "", []),
  sectionmodel("Micro-Learn", {}, "", []),
];
List<sectionmodel> sustain_trust_sectionsList = [
  sectionmodel("Stakeholder Matrix ", {}, "", []),
  sectionmodel("BCG Matrix", {}, "", []),
  sectionmodel("Claims Turn Around", {}, "", []),
];
List<sectionmodel> relationship_stability_sectionsList = [
  sectionmodel("RM Updates", {}, "", []),
  sectionmodel("RMA KAM Updates", {}, "", []),
  sectionmodel("Identified Needs", {}, "", []),
];
List<sectionmodel> innovation_sectionsList = [
  sectionmodel("Product Design", {}, "", []),
  sectionmodel("Partnerships Synergy /Alliance Optimization", {}, "", []),
  sectionmodel("Innovative Tech", {}, "", []),
];
List<sectionmodel> comms_and_updates_sectionsList = [
  sectionmodel("Leaderships Dialogues", {}, "", []),
  sectionmodel("Business Updates", {}, "", []),
  sectionmodel("Contacts Update", {}, "", []),
];
List<sectionmodel> social_impact_sectionsList = [
  sectionmodel("Leadership Dialogues", {}, "", []),
  sectionmodel("Bespoke Reporting", {}, "", []),
  sectionmodel("Project Sponsorship", {}, "", []),
];
List<sectionmodel> service_standards_sectionsList = [
  sectionmodel("Client Fulfilment (Employer )", {}, "", []),
  sectionmodel("Client Fulfilment (Employee)", {}, "", []),
  sectionmodel("Client Fulfilment RMA", {}, "", []),
];

class Goldenwheel extends StatefulWidget {
  const Goldenwheel({super.key});
  @override
  State<Goldenwheel> createState() => _GoldenwheelState();
}

bool _obscureText = true;

final GlobalKey<ScaffoldState> _key = GlobalKey();

class _GoldenwheelState extends State<Goldenwheel> with InactivityLogoutMixin {
  int _counter = 0;

  final List<String> imgList1 = [
    'assets/business_logos/pop_and_spin1.png',
    "assets/business_logos/pop_and_spin2.png",
    "assets/business_logos/pop_and_spin3.png"
  ];

  final List<String> imgList = [
    'https://everestmpu.co.za/wp-content/uploads/2020/06/17.jpg',
    'https://everestmpu.co.za/wp-content/uploads/2020/06/12.jpg',
    'https://everestmpu.co.za/wp-content/uploads/2021/11/0C3A8414.jpg',
  ];
  final List<String> imgList_everest = [
    'assets/everest_images/WhatsApp Image 2024-04-10 at 15.17.09.jpeg',
    'assets/everest_images/WhatsApp Image 2024-04-10 at 15.17.09 (1).jpeg',
    'assets/everest_images/WhatsApp Image 2024-04-10 at 15.17.10.jpeg',
    'assets/everest_images/WhatsApp Image 2024-04-10 at 15.17.10 (1).jpeg',
    'assets/everest_images/WhatsApp Image 2024-04-10 at 15.17.10 (2).jpeg',
    'assets/everest_images/WhatsApp-Image-2023-08-07-at-16.41.43.jpeg',
  ];
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
                              _passwordAttempts < 3) {
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
                              if (_passwordAttempts >= 3) {
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
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.height,
                  color: Colors.grey.withOpacity(0.03),
                  child: Container(
                    width: MediaQuery.of(context).size.height,
                    color: Colors.grey.withOpacity(0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 55,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 55.0, bottom: 8),
                          child: Container(
                            child: CircleAvatar(
                              radius: 36,
                              backgroundColor: Constants.ctaColorLight,
                              child: Center(
                                  // child: SvgPicture.string(svgCode),
                                  child: Icon(
                                Iconsax.user,
                                color: Colors.white,
                              )),
                            ),
                          ),
                        ),
                        Text(
                          Constants.myDisplayname,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontFamily: "TradeGothic",
                              letterSpacing: 0.8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                          child: Text(
                            Constants.myEmail,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontFamily: "TradeGothic",
                                  fontSize: 15.5,
                                  letterSpacing: 0.8,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                          */ /*   Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => admin()));*/ /*
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
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: ListTile(
                    title: Text(
                      "Sales",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xff121212),
                      ),
                    ),
                    //  trailing: Icon(Icons.arrow_forward),
                    leading: Container(
                      height: 25,
                      width: 25,
                      child: SvgPicture.asset("assets/icons/sales_logo.svg",
                          color: Color(0xcc121212)),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExecutivesSalesReport(),
                        ),
                      ).then((_) {
                        Constants.pageLevel = 1;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 30),
                  child: Container(
                    height: 1,
                    color: Color(0x33c2c5cc),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: ListTile(
                    title: Text(
                      "Collections",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xff121212),
                      ),
                    ),
                    //  trailing: Icon(Icons.arrow_forward),
                    leading: Container(
                      height: 25,
                      width: 25,
                      child: SvgPicture.asset(
                          "assets/icons/collections_logo.svg",
                          color: Color(0xcc121212)),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExecutiveCollectionsReport(),
                        ),
                      ).then((_) {
                        Constants.pageLevel = 1;
                      });
                      ;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 30),
                  child: Container(
                    height: 1,
                    color: Color(0x33c2c5cc),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: ListTile(
                    title: Text(
                      "Maintenance",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xff121212),
                      ),
                    ),
                    //  trailing: Icon(Icons.arrow_forward),
                    leading: Container(
                      height: 25,
                      width: 25,
                      child: SvgPicture.asset(
                          "assets/icons/maintanence_report.svg",
                          color: Color(0xcc121212)),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MaintenanceReport(),
                        ),
                      ).then((_) {
                        Constants.pageLevel = 1;
                      });
                      ;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 30),
                  child: Container(
                    height: 1,
                    color: Color(0x33c2c5cc),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: ListTile(
                    title: Text(
                      "Claims",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xff121212),
                      ),
                    ),
                    //  trailing: Icon(Icons.arrow_forward),
                    leading: Container(
                      height: 25,
                      width: 25,
                      child: SvgPicture.asset("assets/icons/claims_logo.svg",
                          color: Color(0xcc121212)),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClaimsReport(),
                        ),
                      ).then((_) {
                        Constants.pageLevel = 1;
                      });
                      ;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 30),
                  child: Container(
                    height: 1,
                    color: Color(0x33c2c5cc),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: ListTile(
                    title: Text(
                      "Reprints",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xff121212),
                      ),
                    ),
                    //  trailing: Icon(Icons.arrow_forward),
                    leading: Container(
                      height: 25,
                      width: 25,
                      child: SvgPicture.asset("assets/icons/reprint_logo.svg",
                          color: Color(0xcc121212)),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReprintsCancellations(),
                        ),
                      ).then((_) {
                        Constants.pageLevel = 1;
                      });
                      ;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 30),
                  child: Container(
                    height: 1,
                    color: Color(0x33c2c5cc),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: ListTile(
                    title: Text(
                      "Pol. Search",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xff121212),
                      ),
                    ),
                    //  trailing: Icon(Icons.arrow_forward),
                    leading: Container(
                      height: 25,
                      width: 25,
                      child: SvgPicture.asset("assets/icons/policy_search.svg",
                          color: Color(0xcc121212)),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PolicyInformation(),
                        ),
                      ).then((_) {
                        Constants.pageLevel = 1;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 30),
                  child: Container(
                    height: 1,
                    color: Color(0x33c2c5cc),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: ListTile(
                    title: Text(
                      "Comms",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xff121212),
                      ),
                    ),
                    //  trailing: Icon(Icons.arrow_forward),
                    leading: Container(
                      height: 25,
                      width: 25,
                      child: SvgPicture.asset(
                          "assets/icons/commission_logo.svg",
                          color: Color(0xcc121212)),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommsReport(),
                        ),
                      ).then((_) {
                        Constants.pageLevel = 1;
                      });
                      ;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 30),
                  child: Container(
                    height: 1,
                    color: Color(0x33c2c5cc),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: ListTile(
                      title: Text(
                        "Morale Index",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Color(0xff121212),
                        ),
                      ),
                      //  trailing: Icon(Icons.arrow_forward),
                      leading: Container(
                        height: 25,
                        width: 25,
                        child: SvgPicture.asset(
                            "assets/icons/people_matters.svg",
                            color: Color(0xcc121212)),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        String hashedInput =
                            _hashPassword(_passwordController.text);
                        print("hashedInput $hashedInput");
                        if (hashedInput == _correctPasswordHash &&
                            _passwordAttempts < 3) {
                          Navigator.of(context).pop(); // Close the dialog
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MoraleIndexReport(),
                            ),
                          ).then((_) {
                            Constants.pageLevel = 1;
                          });
                          _passwordAttempts = 0;
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 30),
                  child: Container(
                    height: 1,
                    color: Color(0x33c2c5cc),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: ListTile(
                      title: Text(
                        "Attendance",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Color(0xff121212),
                        ),
                      ),
                      //  trailing: Icon(Icons.arrow_forward),
                      leading: Container(
                        height: 25,
                        width: 25,
                        child: SvgPicture.asset("assets/icons/attendance.svg",
                            color: Color(0xcc121212)),
                      ),
                      onTap: () {
                        Navigator.of(context).pop(); // Close the dialog
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ComingSoon(),
                          ),
                        ).then((_) {
                          Constants.pageLevel = 1;
                        });
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 30),
                  child: Container(
                    height: 1,
                    color: Color(0x33c2c5cc),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: ListTile(
                      title: Text(
                        "Commision",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Color(0xff121212),
                        ),
                      ),
                      //  trailing: Icon(Icons.arrow_forward),
                      leading: Container(
                        height: 25,
                        width: 25,
                        child: SvgPicture.asset(
                            "assets/icons/commission_logo.svg",
                            color: Color(0xcc121212)),
                      ),
                      onTap: () {
                        Navigator.of(context).pop(); // Close the dialog
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExecutiveCommisionsReport(),
                          ),
                        ).then((_) {
                          Constants.pageLevel = 1;
                        });
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 30),
                  child: Container(
                    height: 1,
                    color: Color(0x33c2c5cc),
                  ),
                ),

                /*  InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => settings()));
                  },
                  child: ListTile(
                    title: Text(
                      "Settings",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xff121212),
                      ),
                    ),
                    //   trailing: Icon(Icons.arrow_forward),
                    leading:
                        Icon(CupertinoIcons.settings, color: Color(0xcc121212)),
                  ),
                ),*/
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 85),
                  child: Container(
                    height: 1,
                    color: Color(0x33c2c5cc),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InkWell(
                    onTap: () {
                      //Sharedprefs.saveUserLoggedInSharedPreference(false);
                      //Sharedprefs.saveUserEmailSharedPreference("");
                      //Sharedprefs.saveUserCecClientIdSharedPreference(-1);
                      //Sharedprefs.saveUserEmpIdSharedPreference(-1);
                      Navigator.of(context).pop();
                      Constants.isLoggedIn = true;
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                          color: Constants.ctaColorLight,
                          borderRadius: BorderRadius.circular(360)),
                      child: Center(
                        child: Text('Sign Out',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: "TradeGothic",
                                fontWeight: FontWeight.normal)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 6,
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
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
                  items: Constants.cec_client_id == 379
                      ? imgList_everest
                          .map((item) => Builder(
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
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
                      : Constants.currentBusinessInfo.logo.isEmpty
                          ? imgList1
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
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: CachedNetworkImage(
                                          imageUrl: item,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Center(
                                              child:
                                                  CircularProgressIndicator()),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 8,
                  crossAxisCount: 4,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 1.4),
                ),
                itemCount: sectionsList.length,
                padding: EdgeInsets.all(2.0),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SectionDetailPage(section: sectionsList[index]),
                        ),
                      );
                    },
                    child: Container(
                      height: 290,
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Stack(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 0.0, right: 8),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Card(
                                      elevation: 6,
                                      surfaceTintColor: Colors.white,
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(360),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.04),
                                              spreadRadius: 2,
                                              blurRadius: 4,
                                              offset: Offset(0, -2),
                                            ),
                                          ],
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 370,
                                        margin: EdgeInsets.only(
                                            right: 0, left: 0, bottom: 4),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: SvgPicture.asset(
                                            sectionsList[index].image,
                                            color: Constants.ctaColorLight,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 55,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        sectionsList[index].id,
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                      ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
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

    super.initState();
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
  Map map;
  String image;
  List<sectionmodel> subsections;
  sectionmodel(this.id, this.map, this.image, this.subsections);
}

class subsectionmodel {
  String id;
  Map map;
  String image;
  subsectionmodel(this.id, this.map, this.image);
}

class SectionDetailPage extends StatelessWidget {
  final sectionmodel section;

  SectionDetailPage({required this.section});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(section.id),
      ),
      body: section.subsections.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: SectionGrid(sections: section.subsections),
            )
          : Center(
              child: Text('No subsections available'),
            ),
    );
  }
}

class SectionGrid extends StatelessWidget {
  final List<sectionmodel> sections;

  SectionGrid({required this.sections});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 8,
        crossAxisCount: 4,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 1.4),
      ),
      itemCount: sections.length,
      padding: EdgeInsets.all(2.0),
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SectionDetailPage(section: sections[index]),
              ),
            );*/
          },
          child: Container(
            height: 290,
            width: MediaQuery.of(context).size.width / 2.5,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 0.0, right: 8),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          child: Card(
                            elevation: 6,
                            surfaceTintColor: Colors.white,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(360),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.04),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: Offset(0, -2),
                                  ),
                                ],
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: 370,
                              margin:
                                  EdgeInsets.only(right: 0, left: 0, bottom: 4),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SvgPicture.asset(
                                  sections[index].image,
                                  color: Colors.blue.withOpacity(0.90),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 55,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              sections[index].id,
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
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
    );
  }
}
