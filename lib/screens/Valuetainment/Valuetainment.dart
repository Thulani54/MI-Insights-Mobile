import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../admin/ClientSearchPage.dart';
import '../../constants/Constants.dart';
import '../../services/inactivitylogoutmixin.dart';
import 'Compliance.dart';
import 'FAQs.dart';

class sectionmodel {
  String id;
  dynamic map;
  String image;
  sectionmodel(this.id, this.map, this.image);
}

class VaLuetainmenthome extends StatefulWidget {
  const VaLuetainmenthome({super.key});

  @override
  State<VaLuetainmenthome> createState() => _VaLuetainmenthomeState();
}

List<sectionmodel> sectionsList = [
  sectionmodel("Sales", {}, "assets/icons/sales_logo.svg"),
  sectionmodel("Collections", {}, "assets/icons/collections_logo.svg"),
  sectionmodel("Maintenance", {}, "assets/icons/maintanence_report.svg"),
  sectionmodel("Claims", {}, "assets/icons/claims_logo.svg"),
  sectionmodel("Compliance", {}, "assets/icons/claims_logo.svg"),
  sectionmodel("FAQs", {}, "assets/icons/claims_logo.svg"),
];

class _VaLuetainmenthomeState extends State<VaLuetainmenthome>
    with InactivityLogoutMixin {
  void _onPageChanged(int index) {
    print('Current Page Index: $index');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                restartInactivityTimer();
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "Micro-Learn",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            if (Constants.allowed_add_assessments)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(360),
                        color: Constants.ctaColorLight),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    )),
              ),
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
                            backgroundColor: Colors.white,
                            child: Container(
                              constraints: BoxConstraints(
                                  minHeight: 300, maxHeight: 400),

                              //padding: EdgeInsets.symmetric(horizontal: 20),
                              child: SingleChildScrollView(
                                physics: NeverScrollableScrollPhysics(),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ClientSearchPage(
                                        onClientSelected: (val) {}),
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
          elevation: 6,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.black.withOpacity(0.6),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      // Constants.ctaColorLight,
                      //Constants.ctaColorLight.withOpacity(0.5),
                      Colors.grey.withOpacity(0.55),
                      Colors.white,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                height: 250,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                              "assets/business_logos/pop_and_spin2.png")),
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
                  padding: const EdgeInsets.only(left: 0.0, bottom: 4, top: 8),
                  child: Text(
                    "PROGRAMMES",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 12),
              child: Container(
                height: 1,
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.15)),
              ),
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
                        (MediaQuery.of(context).size.height / 1.4)),
                itemCount: sectionsList.length,
                padding: EdgeInsets.all(2.0),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                      onTap: () {},
                      child: Container(
                        height: 290,
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                if (sectionsList[index].id == "FAQs") {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FAQs()))
                                      .then((_) {
                                    Constants.pageLevel = 1;
                                  });
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ModulesPage(
                                                moduleid:
                                                    sectionsList[index].id,
                                              ))).then((_) {
                                    Constants.pageLevel = 1;
                                  });
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 0.0, right: 8),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        /*         decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.35)),
                                            borderRadius:
                                                BorderRadius.circular(360)),*/
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
                                                  BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.04),
                                                  spreadRadius: 2,
                                                  blurRadius: 4,
                                                  offset: Offset(0,
                                                      -2), // Offset to show the shadow at the top
                                                ),
                                              ],
                                            ),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 370,
                                            /*     decoration: BoxDecoration(
                                                  color:Colors.white,
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      8),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors
                                                          .grey.withOpacity(0.2))),*/
                                            margin: EdgeInsets.only(
                                                right: 0, left: 0, bottom: 4),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: SvgPicture.asset(
                                                sectionsList[index].image,
                                                // color: Colors.black,
                                                color: Constants.ctaColorLight
                                                    .withOpacity(0.90),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 55,
                                      child: Column(
                                        children: [
                                          Center(
                                              child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              sectionsList[index].id,
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                            ),
                                          )),
                                          Spacer(),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
