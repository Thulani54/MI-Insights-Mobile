import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:crypto/crypto.dart';
//import 'package:device_info_plus/device_info_plus.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:mi_insights/Login.dart';
import 'package:mi_insights/constants/Constants.dart';
import 'package:mi_insights/screens/ComingSoon.dart';
import 'package:mi_insights/screens/PolicyInformation.dart';
import 'package:mi_insights/services/Sales%20Agent/MyChats.dart';
import 'package:mi_insights/services/getAll.dart';
import 'package:mi_insights/services/inactivitylogoutmixin.dart';
import 'package:mi_insights/services/syncAllData().dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/BusinessInfo.dart';
import '../../screens/Sales Agent/SalesAgentCollectionsReport.dart';
import '../../screens/Sales Agent/SalesAgentCommisionsReport.dart';
import '../../screens/Sales Agent/SalesAgentSalesReport.dart';
import '../../utils/image_utils.dart';
import '../../screens/Valuetainment/Valuetainment.dart';

// Define a class to model the quote data
List<sectionmodel> sectionsList = [
  sectionmodel("My Sales", {}, "assets/icons/sales_logo.svg"),
  sectionmodel("My Collect", {}, "assets/icons/collections_logo.svg"),
  sectionmodel("My Comm", {}, "assets/icons/commission_logo.svg"),
  sectionmodel("My Chats", {}, "assets/icons/my_chats.svg"),
  sectionmodel("Micro-Learn", {}, "assets/icons/micro_l.svg"),
];
//ModulesPage

class SalesAgentHomePage extends StatefulWidget {
  const SalesAgentHomePage({
    super.key,
  });

  @override
  State<SalesAgentHomePage> createState() => _SalesAgentHomePageState();
}

final GlobalKey<ScaffoldState> _key = GlobalKey();
bool _obscureText = true;

class _SalesAgentHomePageState extends State<SalesAgentHomePage>
    with InactivityLogoutMixin {
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
  String _locationMessage = "";
  final String _correctPasswordHash = '414e773d5b7e5c06d564f594bf6384d0';

  String _hashPassword(String password) {
    return md5.convert(utf8.encode(password)).toString();
  }

  void _showPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              'Commisions are password protected',
              style: TextStyle(fontSize: 18),
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
              Text(
                'Please enter your employee number to continue',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: 'Password',
                  errorText: _errorMessage.isEmpty ? null : _errorMessage,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          color: Constants.ctaColorLight,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      String hashedInput =
                          _hashPassword(_passwordController.text);
                      String hashedCec_employeeid =
                          _hashPassword(Constants.cec_employeeid.toString());
                      print("hashedInput $hashedInput");
                      print("hashedCec_employeeid $hashedCec_employeeid");
                      print("hashedCec_employeeid ${Constants.cec_employeeid}");
                      if (hashedInput == hashedCec_employeeid &&
                          _passwordAttempts < 3) {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SalesAgentCommisionsReport(),
                          ),
                        ).then((_) {
                          Constants.pageLevel = 1;
                        });
                        _passwordAttempts = 0;
                      } else {
                        setState(() {
                          _errorMessage = "Incorrect Password";
                          _passwordAttempts++;
                          if (_passwordAttempts >= 3) {
                            _errorMessage = "Too many attempts";
                            // Optionally lock the user out or take other action
                          }
                        });
                      }
                      _passwordController.clear();
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: Constants.ctaColorLight,
                            borderRadius: BorderRadius.circular(360)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 14.0, right: 14, top: 5, bottom: 5),
                          child: const Text(
                            'Continue',
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ],
        );
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
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 99) / 2;
    final double itemWidth = size.width / 2;

    return Scaffold(
      key: _key,
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
                          builder: (context) => SalesAgentReport(),
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
                          builder: (context) => SalesAgentCollectionsReport(),
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
                /*Padding(
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
                        child: SvgPicture.asset(
                            "assets/icons/attendance.svg",
                            color: Color(0xcc121212)),
                      ),
                      onTap: () {
                        Navigator.of(context).pop(); // Close the dialog
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AttendanceReport(),
                          ),
                        ).then((_) {
                          Constants.pageLevel = 1;
                        });
                      }),
                ),*/
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
                        Navigator.of(context).pop();
                        String hashedInput =
                            _hashPassword(_passwordController.text);
                        String hashedCec_employeeid =
                            _hashPassword(Constants.cec_employeeid.toString());
                        print("hashedInput $hashedInput");
                        print("hashedCec_employeeid $hashedCec_employeeid");
                        if (hashedInput == hashedCec_employeeid &&
                            _passwordAttempts < 3) {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SalesAgentCommisionsReport(),
                            ),
                          ).then((_) {
                            Constants.pageLevel = 1;
                          });
                          _passwordAttempts = 0;
                        } else {
                          setState(() {
                            _errorMessage = "Incorrect Password";
                            _passwordAttempts++;
                            if (_passwordAttempts >= 3) {
                              _errorMessage = "Too many attempts";
                              // Optionally lock the user out or take other action
                            }
                          });
                        }
                        _passwordController.clear();
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
      floatingActionButton: TripleTapFAB(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 6,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.6),
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
            Container(
              height: 120,
              width: MediaQuery.of(context).size.width,
              child: SvgPicture.asset(
                "assets/logo_main.svg",
                fit: BoxFit.cover,
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
                                              child: _isAssetPath(item)
                                                  ? Image.asset(
                                                      item,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Container(
                                                          color:
                                                              Colors.grey[300],
                                                          child: Center(
                                                            child: Icon(
                                                              Icons
                                                                  .image_not_supported,
                                                              color: Colors
                                                                  .grey[600],
                                                              size: 40,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  : Image.network(
                                                      item,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Container(
                                                          color:
                                                              Colors.grey[300],
                                                          child: Center(
                                                            child: Icon(
                                                              Icons
                                                                  .image_not_supported,
                                                              color: Colors
                                                                  .grey[600],
                                                              size: 40,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      loadingBuilder: (context,
                                                          child,
                                                          loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) return child;
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            value: loadingProgress
                                                                        .expectedTotalBytes !=
                                                                    null
                                                                ? loadingProgress
                                                                        .cumulativeBytesLoaded /
                                                                    loadingProgress
                                                                        .expectedTotalBytes!
                                                                : null,
                                                          ),
                                                        );
                                                      },
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
                      : !Constants.currentBusinessInfo.logo.isEmpty
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
                                                  child: _isAssetPath(item)
                                                      ? Image.asset(
                                                          item,
                                                          fit: BoxFit.cover,
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return Container(
                                                              color: Colors
                                                                  .grey[300],
                                                              child: Center(
                                                                child: Icon(
                                                                  Icons
                                                                      .image_not_supported,
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
                                                                  size: 40,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        )
                                                      : Image.network(
                                                          item,
                                                          fit: BoxFit.cover,
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return Container(
                                                              color: Colors
                                                                  .grey[300],
                                                              child: Center(
                                                                child: Icon(
                                                                  Icons
                                                                      .image_not_supported,
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
                                                                  size: 40,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          loadingBuilder: (context,
                                                              child,
                                                              loadingProgress) {
                                                            if (loadingProgress ==
                                                                null)
                                                              return child;
                                                            return Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                value: loadingProgress
                                                                            .expectedTotalBytes !=
                                                                        null
                                                                    ? loadingProgress
                                                                            .cumulativeBytesLoaded /
                                                                        loadingProgress
                                                                            .expectedTotalBytes!
                                                                    : null,
                                                              ),
                                                            );
                                                          },
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
                                        child: _isAssetPath(item)
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.asset(
                                                  item,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Container(
                                                      color: Colors.grey[300],
                                                      child: Center(
                                                        child: Icon(
                                                          Icons
                                                              .image_not_supported,
                                                          color:
                                                              Colors.grey[600],
                                                          size: 40,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )
                                            : ImageUtils.buildCachedImage(
                                                imageUrl: item,
                                                baseUrl: Constants.insightsBackendBaseUrl,
                                                fit: BoxFit.cover,
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
                                // print("index " + index.toString());
                                if (sectionsList[index].id == "My Sales") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SalesAgentReport())).then((_) {
                                    Constants.pageLevel = 1;
                                  });
                                } else if (sectionsList[index].id ==
                                    "My Collect") {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SalesAgentCollectionsReport()))
                                      .then((_) {
                                    Constants.pageLevel = 1;
                                  });
                                } else if (sectionsList[index].id ==
                                    "Micro-Learn") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VaLuetainmenthome())).then((_) {
                                    Constants.pageLevel = 1;
                                  });
                                } else if (sectionsList[index].id ==
                                    "My Comm") {
                                  _showPasswordDialog();
                                } else if (sectionsList[index].id ==
                                    "My Chats") {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => myChats()))
                                      .then((_) {
                                    Constants.pageLevel = 1;
                                  });
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

  @override
  void initState() {
    getBusinessDetails();
    getAllUsers(
        Constants.cec_client_id.toString(), Constants.cec_client_id.toString());
    getAllBranches(context, Constants.cec_client_id.toString(),
        Constants.cec_client_id.toString());
    //if (Constants.isDataSynced == false) syncAllData(context);
    startInactivityTimer();
    Constants.pageLevel = 1;
    startInactivityTimer();
    _getLocation();

    Future.delayed(Duration(seconds: 3)).then((value) {
      _showMoodDialog(context);
    });
    super.initState();
  }

  void _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don't continue
      setState(() {
        _locationMessage = "Location services are disabled.";
      });
      return;
    }

    // Request permission
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Permissions are denied, next time you could try to request permissions again
      // with the Geolocator.requestPermission() method.
      setState(() {
        _locationMessage = "Location permissions are denied";
      });
      return;
    }

    // If permissions are granted
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

    setState(() {
      _locationMessage =
          "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
    });
  }

  void _showMoodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 12,
              ),
              Text(
                'Welcome back ${Constants.myDisplayname}, how is it going?',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                height: 2,
                decoration: BoxDecoration(
                    color: Constants.ctaColorLight,
                    borderRadius: BorderRadius.circular(360)),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _MoodButton(
                    icon: "assets/icons/Happy.svg",
                    text: 'Happy',
                    color: Colors.green,
                    onPressed: () async {
                      fetchRandomQuote('happy').then((quote) {
                        if (kDebugMode) {
                          print('Random quote: ${quote.quote}');
                        }
                        Navigator.of(context).pop();
                        _showSecondDialog(quote);
                      }).catchError((error) {
                        if (kDebugMode) {
                          print('Error fetching quote: $error');
                        }
                      });
                      String todaysDate = formatDate(DateTime.now());
                      // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                      String? deviceId = '';

                      if (Theme.of(context).platform ==
                          TargetPlatform.android) {
                        /* AndroidDeviceInfo androidInfo =
                            await deviceInfo.androidInfo;*/
                        // deviceId = androidInfo.id;
                        if (kDebugMode) {
                          print("deviceId $deviceId");
                        }
                      } else if (Theme.of(context).platform ==
                          TargetPlatform.iOS) {
                        // IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
                        // deviceId = iosInfo.identifierForVendor;
                        print("deviceId $deviceId");
                      }
                      setMoodLogin(
                        moodId: 3,
                        dateToday: todaysDate,
                        comment: '',
                        deviceId:
                            'excuJzPoIMA:APA91bG63wtMS2j-Hdce6hShxonLnm_39U0p7oc9rcD6-PGQEYIB3dhEzH8ya5QVnoLIXst7Xz6nZhTLLXT7r4ZWlbE6Qm5woFSiOFHkDSJUaFTODY-XWjb5I-uLAOvdboMHbfls_b7U',
                        email: Constants.myEmail,
                        clientId: Constants.cec_client_id,
                        userMood: '/Content/Images/Emotions/Happy.png',
                      ).catchError((error) {
                        print('Error setting mood: $error');
                      });
                    },
                  ),
                  _MoodButton(
                    icon: "assets/icons/unsure_2.svg",
                    text: 'Unsure',
                    color: Colors.amber,
                    onPressed: () async {
                      fetchRandomQuote('unsure').then((quote) {
                        if (kDebugMode) {
                          print('Random quote: ${quote.quote}');
                        }
                        Navigator.of(context).pop();
                        _showSecondDialog(quote);
                      }).catchError((error) {
                        if (kDebugMode) {
                          print('Error fetching quote: $error');
                        }
                      });
                      String todaysDate = formatDate(DateTime.now());
                      // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                      String? deviceId = '';

                      if (Theme.of(context).platform ==
                          TargetPlatform.android) {
                        /* AndroidDeviceInfo androidInfo =
                            await deviceInfo.androidInfo;*/
                        // deviceId = androidInfo.id;
                        if (kDebugMode) {
                          print("deviceId $deviceId");
                        }
                      } else if (Theme.of(context).platform ==
                          TargetPlatform.iOS) {
                        /* IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
                        deviceId = iosInfo.identifierForVendor;*/
                        if (kDebugMode) {
                          print("deviceId $deviceId");
                        }
                      }
                      setMoodLogin(
                        moodId: 1,
                        dateToday: todaysDate,
                        comment: '',
                        deviceId: deviceId!,
                        email: Constants.myEmail,
                        clientId: Constants.cec_client_id,
                        userMood: '/Content/Images/Emotions/Unsure.png',
                      ).catchError((error) {
                        print('Error setting mood: $error');
                      });
                    },
                  ),
                  _MoodButton(
                    icon: "assets/icons/Sad.svg",
                    text: 'Sad',
                    color: Colors.red,
                    onPressed: () async {
                      fetchRandomQuote('sad').then((quote) {
                        if (kDebugMode) {
                          print('Random quote: ${quote.quote}');
                        }
                        Navigator.of(context).pop();
                        _showSecondDialog(quote);
                      }).catchError((error) {
                        if (kDebugMode) {
                          print('Error fetching quote: $error');
                        }
                      });
                      String todaysDate = formatDate(DateTime.now());
                      //  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                      String? deviceId = '';

                      if (Theme.of(context).platform ==
                          TargetPlatform.android) {
                        /*      AndroidDeviceInfo androidInfo =
                            await deviceInfo.androidInfo;
                        deviceId = androidInfo.id;
                        if (kDebugMode) {
                          print("deviceId $deviceId");
                        }*/
                      } else if (Theme.of(context).platform ==
                          TargetPlatform.iOS) {
                        /*      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
                        deviceId = iosInfo.identifierForVendor;*/
                        if (kDebugMode) {
                          print("deviceId $deviceId");
                        }
                      }
                      setMoodLogin(
                        moodId: 1,
                        dateToday: todaysDate,
                        comment: '',
                        deviceId: deviceId,
                        email: Constants.myEmail,
                        clientId: Constants.cec_client_id,
                        userMood: '/Content/Images/Emotions/Sad.png',
                      ).catchError((error) {
                        print('Error setting mood: $error');
                      });
                    },
                  ),
                ],
              ),
              Container(
                height: 1,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(360)),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSecondDialog(Quote quote) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 25,
              ),
              SvgPicture.asset(
                "assets/icons/Happy.svg",
                color: Colors.green,
                width: 75,
                height: 75,
              ),
              SizedBox(
                height: 12,
              ),
              /* const Text(
                'Let us fight covid-19',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),*/
              Text(
                quote.author.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                quote.quote.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                restartInactivityTimer();
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: Constants.ctaColorLight,
                      borderRadius: BorderRadius.circular(360)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 14.0, right: 14, top: 5, bottom: 5),
                    child: const Text(
                      'Continue',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            ),
          ],
        );
      },
    );
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
          print("datax_business $data");
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
  Map map;
  String image;
  sectionmodel(this.id, this.map, this.image);
}

class _MoodButton extends StatefulWidget {
  final String icon;
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const _MoodButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  __MoodButtonState createState() => __MoodButtonState();
}

class __MoodButtonState extends State<_MoodButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _sizeAnimation = Tween<double>(begin: 0.75, end: 1.5).animate(_controller);
    _colorAnimation =
        ColorTween(begin: Colors.grey, end: widget.color).animate(_controller);

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        widget.onPressed();

        await _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              _controller.forward();

              print("gjhhjh");
              /*    Future.delayed(Duration(seconds: 2)).then((value) {
                Navigator.pop(context);
                _showSecondDialog();
              });*/
            },
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _sizeAnimation.value,
                  child: SvgPicture.asset(
                    widget.icon,
                    color: _colorAnimation.value,
                    width: widget.icon == "assets/icons/unsure_2.svg" ? 75 : 70,
                    height:
                        widget.icon == "assets/icons/unsure_2.svg" ? 75 : 70,
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            widget.text,
            style: TextStyle(
                color: Color(0xff337ab7),
                fontWeight: FontWeight.bold,
                fontSize: 13),
          ),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Quote {
  final int id;
  final String quote;
  final String? author;
  final String type;
  final String? lastUpdate;
  final String? timestamp;

  Quote({
    required this.id,
    required this.quote,
    this.author,
    required this.type,
    this.lastUpdate,
    this.timestamp,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'],
      quote: json['quote'],
      author: json['author'],
      type: json['type'],
      lastUpdate: json['last_update'],
      timestamp: json['timestamp'],
    );
  }
}

Future<Quote> fetchRandomQuote(String type) async {
  final url = Uri.parse(
      '${Constants.insightsBackendBaseUrl}admin/getQuotes?type=$type');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    List<dynamic> quotesJson = json.decode(response.body);

    if (quotesJson.isNotEmpty) {
      List<Quote> quotes =
          quotesJson.map((quoteJson) => Quote.fromJson(quoteJson)).toList();
      final randomIndex = Random().nextInt(quotes.length);
      return quotes[randomIndex];
    } else {
      throw Exception('No quotes found');
    }
  } else {
    throw Exception('Failed to load quotes');
  }
}

Future<void> setMoodLogin({
  required int moodId,
  required String dateToday,
  String? comment,
  required String deviceId,
  required String email,
  required int clientId,
  required String userMood,
}) async {
  final url =
      Uri.parse('${Constants.insightsBackendBaseUrl}admin/setMoodLogin');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'moodId': moodId.toString(),
      'dateToday': dateToday,
      'comment': comment ?? '', // Use an empty string if no comment is provided
      'device_id': deviceId,
      'email': email,
      'clientId': clientId.toString(),
      'userMood': userMood,
    },
  );

  if (response.statusCode == 200) {
    // Handle the response if the status code is 200
    print('Mood set successfully');
  } else {
    // Handle the error if the status code is not 200
    print('Failed to set mood. Status code: ${response.statusCode}');
  }
}

String formatDate(DateTime date) {
  return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

class TripleTapFAB extends StatefulWidget {
  @override
  _TripleTapFABState createState() => _TripleTapFABState();
}

class _TripleTapFABState extends State<TripleTapFAB> {
  int _tapCount = 0;
  Timer? _timer;

  void _handleTap() {
    _tapCount++;

    if (_tapCount == 3) {
      if (kDebugMode) {
        print("Triple tap detected");
      }

      getLocation();
      _createPanicAlert();
      _tapCount = 0;
      _timer?.cancel();
      return;
    }

    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer(Duration(milliseconds: 500), () {
      _tapCount = 0; // Reset tap count
    });
  }

  void getLocation() async {
    //  print('Printing text before getCurrentLocation()');

    // print(position);
  }

  Future<void> _createPanicAlert() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    final url = Uri.parse('${Constants.baseUrl2}/files/create_panic_alert/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'client_id': Constants.cec_client_id,
        'user_name': Constants.myDisplayname,
        'created_at': DateTime.now().toIso8601String(),
        "cec_employeeid": Constants.cec_employeeid,
        'lat': '${position.latitude}',
        'long': '${position.longitude}',
        'status': 'new',
        'user_feedback': '-',
        'additional_info': '',
        'administrative_notes': '',
        'resolution_details': '',
        'feedback_comments': '',
      }),
    );

    if (response.statusCode == 201) {
      print('Panic alert created successfully.');
    } else {
      print('Failed to create panic alert: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(360),
        ),
        backgroundColor: Constants
            .ctaColorLight, // Replace with your Constants.ctaColorLight
        child: Text(
          "!",
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
        onPressed: () {
          _handleTap();
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Clean up the timer when the widget is disposed
    super.dispose();
  }
}
