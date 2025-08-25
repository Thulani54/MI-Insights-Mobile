import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../Login.dart';
import '../../../constants/Constants.dart';
import '../../Admin/BannerManagement.dart';
import '../../Admin/LogoManagement.dart';
import '../../Admin/NotificationManagement.dart';
import '../../Admin/PosAppLogs.dart';
import '../../Admin/ReportsGenerator.dart';
import '../../Admin/UserRoles.dart';
import '../../Custom/MoralIndex.dart';
import '../../MiddleManagement/AttendanceRegister.dart';
import '../../MiddleManagement/MpsDebitView.dart';
import '../../MiddleManagement/ReprintsAndCancellationsRequest.dart';
import '../ManageValuetainment/Managevalutainment.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  List<sectionmodel> sectionsList = [
    sectionmodel("Micro-Learn", {}, "assets/icons/micro_l.svg"),
    sectionmodel("User Roles", {}, "assets/icons/micro_l.svg"),
    sectionmodel("Logo Management", {}, "assets/icons/micro_l.svg"),
    sectionmodel("Notifications", {}, "assets/icons/micro_l.svg"),
    sectionmodel("Banner Management", {}, "assets/icons/micro_l.svg"),
    sectionmodel("Custom Report Generators", {}, "assets/icons/micro_l.svg"),
    sectionmodel("POS App Audit Trail", {}, "assets/icons/micro_l.svg"),
    sectionmodel("POS Reprint Requests", {}, "assets/icons/micro_l.svg"),
    sectionmodel("MPS Future Transactions", {}, "assets/icons/micro_l.svg"),
    sectionmodel("Attendance Register", {}, "assets/icons/micro_l.svg"),
    sectionmodel("Morale Index", {}, "assets/icons/micro_l.svg"),
  ];
  Map<String, List<sectionmodel>> m1 = {
    "executive": [
      sectionmodel(
          "Micro-Learn", Managevalutainment(), "assets/icons/micro_l.svg"),
      sectionmodel("User Roles", {}, "assets/icons/micro_l.svg"),
      sectionmodel("Logo Management", {}, "assets/icons/micro_l.svg"),
      sectionmodel("Notifications", {}, "assets/icons/micro_l.svg"),
      sectionmodel("Banner Management", {}, "assets/icons/micro_l.svg"),
      sectionmodel("Custom Report Generators", {}, "assets/icons/micro_l.svg"),
      sectionmodel("POS App Audit Trail", {}, "assets/icons/micro_l.svg"),
      sectionmodel("POS Reprint Requests", {}, "assets/icons/micro_l.svg"),
      sectionmodel("MPS Future Transactions", {}, "assets/icons/micro_l.svg"),
    ],
  };
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final List<String> imgList1 = [
    'assets/business_logos/pop_and_spin1.png',
    "assets/business_logos/pop_and_spin2.png",
    "assets/business_logos/pop_and_spin3.png",
  ];
  final CarouselSliderController _controller = CarouselSliderController();
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                            padding:
                                const EdgeInsets.only(top: 55.0, bottom: 8),
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
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 16),
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
          shadowColor: Colors.grey.withOpacity(0.3),
          surfaceTintColor: Colors.white,
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
            children: [
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
                    items: imgList1
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
                                      width: MediaQuery.of(context).size.width,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 0.0),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 1.0),
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
                        .toList(),
                  ),
                ),
              ),
              ListView.builder(
                itemCount: sectionsList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        if (sectionsList[index].id == "Micro-Learn") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Managevalutainment()));
                        } else if (sectionsList[index].id == "User Roles") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserRoles()));
                        } else if (sectionsList[index].id ==
                            "Banner Management") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BannerManagement()));
                        } else if (sectionsList[index].id ==
                            "Custom Report Generators") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReportGenerators()));
                        } else if (sectionsList[index].id ==
                            "POS App Audit Trail") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Posapplogs()));
                        } else if (sectionsList[index].id ==
                            "POS Reprint Requests") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ReprintsandcancellationsrequestMid()));
                        } else if (sectionsList[index].id ==
                            "MPS Future Transactions") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MpsDebitView()));
                        } else if (sectionsList[index].id ==
                            "Logo Management") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LogoManagement()));
                        } else if (sectionsList[index].id ==
                            "Attendance Register") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AttendanceRegisterScreen()));
                        } else if (sectionsList[index].id == "Morale Index") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MoraleIndex()));
                        } else if (sectionsList[index].id == "Notifications") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NotificationManagement()));
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(36),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, top: 8, bottom: 8, right: 8),
                          child: Text(
                            "${index + 1}) " + sectionsList[index].id,
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}

class sectionmodel {
  String id;
  dynamic map;
  String image;
  sectionmodel(this.id, this.map, this.image);
}
