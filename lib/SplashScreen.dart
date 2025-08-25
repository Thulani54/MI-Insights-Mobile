import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mi_insights/screens/OnboardingScreen.dart';
import 'package:mi_insights/services/getAll.dart';
import 'package:mi_insights/services/sharedpreferences.dart';
import 'package:mi_insights/services/syncAllData().dart';
import 'package:mi_insights/services/window_manager.dart';

import 'Login.dart';
import 'constants/Constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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

              /*Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  child: SvgPicture.asset(
                    "assets/logo_main.svg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),*/
              /*Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    "assets/icons/customcolor_logo_transparent_background.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),*/

              /*  if (Constants.currentBusinessInfo.logo.isNotEmpty)
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: CachedNetworkImage(
                    imageUrl: Constants.currentBusinessInfo.logo,
                    */ /*   placeholder: (context, url) => Container(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator()),*/ /*
                    // errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),*/
              // if(Constants.currentBusinessInfo.)

              Spacer(),
              SpinKitDualRing(
                color: Constants.ctaColorLight,
                size: 60.0,
                lineWidth: 2,
              ),
              Spacer(),
              Text(
                "Copyright (c) 2012-${DateTime.now().year} MI Group.",
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(
                height: 35,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    //Constants.isTwoMountains = true;
    //ray@lpjames.com
    secureScreen();
    Sharedprefs.getUserLoggedInSharedPreference().then((value) {
      Constants.screenWidth = MediaQuery.of(context).size.width;
      Constants.screenHeight = MediaQuery.of(context).size.height;
      if (value != null) Constants.isLoggedIn = value;
      if (kDebugMode) {
        print("valuerdg $value");
      }

      // Constants.myEmail = value.email!;
      // //print(value);
      // Constants.myUid = value.uid;
      // Constants.myDisplayname = value.displayName!;
      Sharedprefs.getUserNameSharedPreference().then((value) {
        if (value != null) Constants.myDisplayname = value.toString();
      });
      Sharedprefs.getCecClientIdSharedPreference().then((value) {
        if (value != null) Constants.cec_client_id = value;
      });
      Sharedprefs.getEmpIdSharedPreference().then((value) {
        if (value != null) Constants.cec_employeeid = value;
      });
      Sharedprefs.getUserEmailSharedPreference().then((value) {
        if (value != null) Constants.myEmail = value.toString();
      });
      Sharedprefs.getUserCellSharedPreference().then((value) {
        if (value != null) Constants.myCell = value.toString();
      });
      Sharedprefs.getUserUidSharedPreference().then((value) {
        if (value != null) Constants.myUid = value.toString();
        if (kDebugMode) {
          print("value $value");
        }
      });
      getAllUsers(Constants.cec_client_id.toString(),
          Constants.cec_client_id.toString());
      getAllBranches(context, Constants.cec_client_id.toString(),
          Constants.cec_client_id.toString());
      //syncAllData(context);
    });
    // Agent credentials
    // User :ray@lpjames.com
    // Password :12345
    //
    // Capturer credentials
    // User: raybranch@lpjames.com
    // Password: 12345
    Future.delayed(Duration(seconds: 6), () {
      Constants.account_type = "sales_agent";
      if (Constants.myEmail.toLowerCase() ==
          "Master@everestmpu.com".toLowerCase()) {
        Constants.account_type = "executive";
      } else if (Constants.myEmail.toLowerCase() ==
          "Eleanorp@everestmpu.co.za".toLowerCase()) {
        Constants.account_type = "executive";
      } else if (Constants.myEmail.toLowerCase() ==
          "Dannykhesa@everestmpu.co.za".toLowerCase()) {
        Constants.account_type = "executive";
      } else if (Constants.myEmail.toLowerCase() ==
          "Mbalim@everestmpu.co.za".toLowerCase()) {
        Constants.account_type = "executive";
      } else if (Constants.myEmail.toLowerCase() ==
          "mshezi@randmutual.co.za".toLowerCase()) {
        Constants.account_type = "executive";
      } else if (Constants.myEmail.toLowerCase() ==
          "Gengelbrecht@randmutual.co.za".toLowerCase()) {
        Constants.account_type = "executive";
      } else if (Constants.myEmail.toLowerCase() !=
          "Gomotsho@miinsights.co.za".toLowerCase()) {
        Constants.account_type = "executive";
      } else if (Constants.myEmail.toLowerCase() !=
          "kenneth@miinsights.co.za".toLowerCase()) {
        Constants.account_type = "executive";
      } else if (Constants.myEmail.toLowerCase() !=
          "mogoere@miinsights.co.za".toLowerCase()) {
        Constants.account_type = "executive";
      } else if (Constants.myEmail.toLowerCase() !=
          "superuser@miinsights.co.za".toLowerCase()) {
        Constants.account_type = "executive";
      }
      print("hgjdgf ${Constants.new_timesOpened}");
      if (Constants.new_timesOpened == 0 || Constants.showOnboardingScreen) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => OnBoardingPage()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    });

    super.initState();
  }
}
