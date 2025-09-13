import 'dart:convert';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mi_insights/SplashScreen.dart';
import 'package:mi_insights/services/AppVersionChecker.dart';
import 'package:mi_insights/services/sharedpreferences.dart';
import 'package:mi_insights/services/window_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/EnvironmentConfig.dart';
import 'constants/Constants.dart';
import 'firebase_options.dart';
import 'models/BusinessInfo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
/*
  Constants.analytics_instance = FirebaseAnalytics.instance;
  Constants.analytics_observer =
      FirebaseAnalyticsObserver(analytics: Constants.analytics_instance!);
  await Constants.analytics_instance!.logAppOpen();
*/
  AppConfig.setEnvironment(EnvironmentType.uat);

  runApp(const MyApp());

  Sharedprefs.getLogoSharedPreference().then((value) {
    if (value != null) {
      Constants.logoUrl = value;
    }
    //print("dffgfg " + Constants.logoUrl);
  });

  getSavedBusinessInfo();
  //getDeviceInfo();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String currentVersion = packageInfo.version;
  Constants.myAppVersion = currentVersion;
  print("Current version0: $currentVersion");
  generateRandomDigits(14);
  // Constants.isAdmin = true;
}

String generateRandomDigits(int length) {
  Random random = Random();
  String result = '';

  for (int i = 0; i < length; i++) {
    result += random.nextInt(10).toString();
  }
  if (kDebugMode) {
    print(result);
  }

  return result;
}

/*Future<void> getDeviceInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  try {
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      Constants.device_id = iosInfo.identifierForVendor ?? 'Unknown';
      Constants.device_model = iosInfo.model ?? 'Unknown';
      Constants.device_os_version = "Ios_" + iosInfo.systemVersion ?? 'Unknown';
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      Constants.device_id = androidInfo.id ?? 'Unknown';
      Constants.device_os_version = "Android_${androidInfo.version.sdkInt}";
      Constants.device_model = androidInfo.model ?? 'Unknown';
    }
    print(
        'Running on ${Constants.device_os_version} ${Constants.device_model} with ID ${Constants.device_id}');
  } catch (e) {
    print('Failed to get device info: $e');
    // Handle the error or set default values
    Constants.device_id = 'Unknown';
    Constants.device_model = 'Unknown';
    Constants.device_os_version = 'Unknown';
  }
}*/

Future<BusinessInfo?> getSavedBusinessInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? businessInfoJson = prefs.getString('businessInfo');
  if (businessInfoJson != null) {
    Map<String, dynamic> json = jsonDecode(businessInfoJson);
    print("businessInfoJson " + json.toString());
    Constants.currentBusinessInfo = BusinessInfo.fromJson(json);

    return BusinessInfo.fromJson(json);
  }
  return null;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MI Insights',
      theme: ThemeData(
        /*   colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.grey.withOpacity(0.15)),*/
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }

  @override
  void initState() {
    super.initState();

    //Constants.InsightsReportsbaseUrl = "http://192.168.1.111:8000";
    //Constants.baseUrl2 = "http://192.168.0.228:8001";
    //Constants.InsightsReportsbaseUrl = "http://192.168.0.172:8000";
    //Constants.posAppBaseUrl = "http://192.168.0.228:9008";
    //Constants.posAppBaseUrl = "http://192.168.1.111:9008";
    //https:insights.dedicated.co.za:4335

    Constants.account_type = "sales_agent";

    Constants.myContext = context;
    getVersionNumber();
    secureScreen();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    Sharedprefs.getCecClientIdSharedPreference().then((value) {
      if (value != null) Constants.cec_client_id = value;
    });
    Sharedprefs.getEmpIdSharedPreference().then((value) {
      if (value != null) Constants.cec_employeeid = value;
    });
    //Constants.InsightsReportsbaseUrl = "https://insights.dedicated.co.za:808";
    if (Constants.cec_client_id.toString().isNotEmpty &&
        Constants.cec_employeeid.toString().isNotEmpty) {
      checkTermsAccepted(Constants.cec_client_id, Constants.cec_employeeid);
    }
  }

  getVersionNumber() async {
    String platform = 'iOS'; // or 'Android'
    AppVersionChecker versionChecker = AppVersionChecker();
    await versionChecker.checkAppVersion(platform);
    getIncrementCount();
  }

  Future<int?> getIncrementCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? timesOpened = prefs.getInt('times_opened');
    Constants.requirePassword = prefs.getBool('require_password') ?? true;
    Constants.accepted_terms = prefs.getBool('accepted_terms') ?? false;
    int new_timesOpened = 0;

    if (timesOpened != null) {
      /*    Sharedprefs.getUserEmailSharedPreference2().then((value) {
        print("emailvbvh1 ${value}");
      });*/
      new_timesOpened = timesOpened + 1; // Increment properly
      prefs.setInt('times_opened', new_timesOpened);
      //print("new_timesOpened $new_timesOpened");
      Constants.new_timesOpened = new_timesOpened;

      if (new_timesOpened % 5 == 0) {
        prefs.setBool('require_password', true);
        //print('Times opened is a multiple of 5!');
        Constants.showOnboardingScreen = true;
      }
    } else {
      new_timesOpened = 1; // Initialize count if it doesn't exist
      prefs.setInt('times_opened', new_timesOpened);
      //print("new_timesOpened 1");
    }

    return timesOpened;
  }

  Future<void> checkTermsAccepted(int empId, int cecClientId) async {
    String url = "${Constants.insightsbaseUrl}files/check_terms_acceptance/";
    try {
      http.Response response = await http.get(Uri.parse(url));
      if (kDebugMode) {
        //print('Response status: ${response.statusCode}');
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
        //print("Terms accepted: $accepted");
      } else {
        //print("Error: Unable to check terms acceptance.");
      }
    } catch (e) {
      //print("Exception caught: $e");
    }
  }

/*  List<FlSpot> processDataForSaleCount(String jsonString) {
    List<dynamic> jsonData = jsonDecode(jsonString);
    Map<int, int> dailySalesCount1a = {};
    Map<int, int> dailySalesCount1b = {};
    Map<int, int> dailySalesCount1c = {};
    int monthlyTotal = 0; // Monthly total counter

    for (var element in jsonData) {
      if (element is Map<String, dynamic>) {
        DateTime date = DateTime.parse(element['sale_datetime']);

        // Only consider dates in the current month
        if (date.month == DateTime.now().month &&
            date.year == DateTime.now().year) {
          dailySalesCount1a.update(date.day, (value) => value + 1,
              ifAbsent: () => 1);
          if (element["quote_status"] == "Inforced")
            dailySalesCount1b.update(date.day, (value) => value + 1,
                ifAbsent: () => 1);
          if (element["quote_status"] != "Inforced")
            dailySalesCount1c.update(date.day, (value) => value + 1,
                ifAbsent: () => 1);
          monthlyTotal += 1; // Increment the monthly total
        }
      }
    }

    List<FlSpot> spots = [];
    spots1a = [];
    spots1b = [];
    spots1c = [];
    dailySalesCount1a.forEach((day, count) {
      spots1a.add(FlSpot(day.toDouble(), count.toDouble()));
      //print("maxY ${maxY}");

      if (count > maxY) {
        maxY = count;
      }
    });
    dailySalesCount1b.forEach((day, count) {
      spots1b.add(FlSpot(day.toDouble(), count.toDouble()));
      if (count > maxY) {
        maxY = count;
      }
    });
    dailySalesCount1c.forEach((day, count) {
      spots1c.add(FlSpot(day.toDouble(), count.toDouble()));
      if (count > maxY) {
        maxY = count;
      }
    });

    // Here you can handle the monthly total as needed
    print("Monthly Total Sales: $monthlyTotal");

    return spots;
  }*/
}
